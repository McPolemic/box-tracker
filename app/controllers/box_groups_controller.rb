class BoxGroupsController < ApplicationController
  before_action :set_box_group, only: %i[ show edit update destroy add_box remove_box ]

  # GET /box_groups or /box_groups.json
  def index
    @box_groups = BoxGroup.all
  end

  # GET /box_groups/1 or /box_groups/1.json
  def show
  end

  # GET /box_groups/new
  def new
    @box_group = BoxGroup.new
  end

  # GET /box_groups/1/edit
  def edit
  end

  # POST /box_groups or /box_groups.json
  def create
    @box_group = BoxGroup.new(box_group_params)

    respond_to do |format|
      if @box_group.save
        format.html { redirect_to @box_group, notice: "Box group was successfully created." }
        format.json { render :show, status: :created, location: @box_group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @box_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /box_groups/1 or /box_groups/1.json
  def update
    respond_to do |format|
      if @box_group.update(box_group_params)
        format.html { redirect_to @box_group, notice: "Box group was successfully updated." }
        format.json { render :show, status: :ok, location: @box_group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @box_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /box_groups/1 or /box_groups/1.json
  def destroy
    @box_group.destroy!
    respond_to do |format|
      format.html { redirect_to box_groups_path, status: :see_other, notice: "Box group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_box
    @box_group = BoxGroup.find(params[:id])
    box = Box.find(params[:box_id])
    unless @box_group.boxes.include?(box)
      @box_group.boxes << box
    end
    redirect_to @box_group, notice: "Box ##{box.id} was added to the group."
  end

  def remove_box
    @box_group = BoxGroup.find(params[:id])
    box = Box.find(params[:box_id])
    if @box_group.boxes.include?(box)
      @box_group.boxes.destroy(box)
    end
    redirect_to @box_group, notice: "Box ##{box.id} was removed from the group."
  end

  # POST /box_groups/bulk_add
  def bulk_add
    box_ids = params[:box_ids] || []
    group_option = params[:group_option]

    if box_ids.empty?
      redirect_back fallback_location: boxes_path, alert: "No boxes selected." and return
    end

    if group_option.to_s.start_with?("existing_")
      group_id = group_option.sub("existing_", "")
      box_group = BoxGroup.find_by(id: group_id)
      unless box_group
        redirect_back fallback_location: boxes_path, alert: "Selected group not found." and return
      end
    elsif group_option == "new"
      display_name = params[:new_group_display_name]
      notes = params[:new_group_notes]
      if display_name.blank?
        redirect_back fallback_location: boxes_path, alert: "New group must have a display name." and return
      end
      box_group = BoxGroup.create(display_name: display_name, notes: notes)
    else
      redirect_back fallback_location: boxes_path, alert: "Invalid group option." and return
    end

    boxes_added = 0
    box_ids.each do |box_id|
      box = Box.find_by(id: box_id)
      next unless box
      unless box_group.boxes.include?(box)
        box_group.boxes << box
        boxes_added += 1
      end
    end

    notice = "Added #{boxes_added} boxes to group '#{box_group.display_name}'."
    redirect_to boxes_path, notice: notice
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_box_group
      @box_group = BoxGroup.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def box_group_params
      params.require(:box_group).permit(:display_name, :notes)
    end
end
