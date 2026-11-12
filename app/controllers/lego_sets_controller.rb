class LegoSetsController < ApplicationController
  before_action :set_service, only: [:index, :create]
  before_action :initialize_sandbox_session

  # GET /lego_sets
  def index
    @lego_sets = LegoSet.all.order(created_at: :desc)

    # Auto-seed the first featured set on a brand-new database so visitors never see an empty screen
    if @lego_sets.empty?
      @service.fetch_set("42207-1")
      @lego_sets = LegoSet.all.order(created_at: :desc)
    end

    # Restore the user's currently active set from their session, or default to the first featured set
    @selected_set = LegoSet.find_by(id: session[:active_set_id]) ||
                    @lego_sets.find { |s| s.set_num == "42207-1" } ||
                    @lego_sets.first

    session[:active_set_id] = @selected_set&.id
    @inventory_parts = @selected_set ? @selected_set.inventory_parts.includes(:part) : []
  end

  # GET /lego_sets/:id
  def show
    @lego_sets = LegoSet.all.order(created_at: :desc)
    @selected_set = LegoSet.find(params[:id])
    session[:active_set_id] = @selected_set.id
    @inventory_parts = @selected_set.inventory_parts.includes(:part)

    respond_to do |format|
      format.html { render :index }
      format.turbo_stream
    end
  end

  # POST /lego_sets
  def create
    raw_num = params[:set_num].to_s.strip
    
    if raw_num.blank?
      @error_message = "Please enter a valid set number."
      return render_error
    end

    # Automatically append '-1' for Rebrickable API compatibility if no variant suffix is provided
    set_num = raw_num.include?("-") ? raw_num : "#{raw_num}-1"

    @selected_set = @service.fetch_set(set_num)

    if @selected_set
      session[:active_set_id] = @selected_set.id
      @lego_sets = LegoSet.all.order(created_at: :desc)
      @inventory_parts = @selected_set.inventory_parts.includes(:part)
      
      respond_to do |format|
        format.html { redirect_to lego_set_path(@selected_set) }
        format.turbo_stream
      end
    else
      @error_message = "Set not found. Double check your set number (ex: 42207)."
      render_error
    end
  end

  # DELETE /lego_sets/:id
  def destroy
    set_to_delete = LegoSet.find(params[:id])
    was_active = (session[:active_set_id] == set_to_delete.id)

    # Remove any saved piece counts belonging to this set from the session cookie
    set_to_delete.inventory_part_ids.each do |part_id|
      session[:sandbox_inventory].delete(part_id.to_s)
    end

    set_to_delete.destroy

    @lego_sets = LegoSet.all.order(created_at: :desc)

    if was_active
      @selected_set = @lego_sets.first
      session[:active_set_id] = @selected_set&.id
    else
      @selected_set = LegoSet.find_by(id: session[:active_set_id]) || @lego_sets.first
    end

    @inventory_parts = @selected_set ? @selected_set.inventory_parts.includes(:part) : []

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to root_path }
    end
  end

  # POST /lego_sets/:id/toggle_part
  # STATELESS CONSOLE MANAGER: Coordinates user counters directly via the browser cookie arrays
  def toggle_part
    @selected_set = LegoSet.find(params[:id])
    session[:active_set_id] = @selected_set.id
    @inventory_part = @selected_set.inventory_parts.find(params[:inventory_part_id])
    part_key = @inventory_part.id.to_s

    # Extract current tracking layout baseline parameter
    current_count = session[:sandbox_inventory][part_key] || 0

    if params[:operation] == "decrement"
      current_count -= 1 if current_count > 0
    else
      # Increment strictly up to the required target quantity without wrapping to zero
      current_count += 1 if current_count < @inventory_part.quantity
    end

    # Commit state cleanly straight onto the request cookie headers
    session[:sandbox_inventory][part_key] = current_count

    @inventory_parts = @selected_set.inventory_parts.includes(:part)

    respond_to do |format|
      format.turbo_stream { render :toggle_part, status: :ok }
      format.html { redirect_to lego_set_path(@selected_set) }
    end
  end

  private

  def set_service
    @service = RebrickableService.new
  end

  def initialize_sandbox_session
    epoch_file = Rails.root.join("tmp/db_epoch.txt")
    current_epoch = File.exist?(epoch_file) ? File.read(epoch_file).strip : "default"

    if session[:db_epoch] != current_epoch
      session[:sandbox_inventory] = {}
      session[:active_set_id] = nil
      session[:db_epoch] = current_epoch
    end

    session[:sandbox_inventory] ||= {}
  end

  def render_error
    respond_to do |format|
      format.html { 
        @lego_sets = LegoSet.all.order(created_at: :desc)
        flash.now[:alert] = @error_message
        render :index 
      }
      format.turbo_stream { render 'error' }
    end
  end
end
