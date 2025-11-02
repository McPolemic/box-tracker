class BoxesController < ApplicationController
  before_action :set_box, only: %i[ show edit update destroy ]

  # GET /boxes
  def index
    @boxes = Box.all
    @box_groups = BoxGroup.all
  end

  # GET /boxes/1
  def show
  end

  # GET /boxes/new
  def new
    @box = Box.new
  end

  # GET /boxes/1/edit
  def edit
  end

  # POST /boxes
  def create
    @box = Box.new(box_params.except(:uploaded_images, :box_group_ids))

    if @box.save
      assign_box_group if box_params[:box_group_ids].present?
      attach_uploaded_images if box_params[:uploaded_images]
      redirect_to @box, notice: "Box was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /boxes/1
  def update
    if @box.update(box_params.except(:uploaded_images, :remove_image_ids, :box_group_ids))
      assign_box_group if box_params.has_key?(:box_group_ids)
      remove_marked_images if box_params[:remove_image_ids]
      attach_uploaded_images if box_params[:uploaded_images]
      redirect_to @box, notice: "Box was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /boxes/1
  def destroy
    @box.destroy!
    redirect_to boxes_path, notice: "Box was successfully destroyed."
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_box
      @box = Box.find(params[:id])
    end

    # Permit parameters, including an array for uploaded images.
    def box_params
      params.require(:box).permit(:display_name, :contents, :box_group_ids, { uploaded_images: [], remove_image_ids: [] })
    end

    def uploaded_images_params
      box_params[:uploaded_images].reject(&:blank?)
    end

    # For each uploaded file, create an Image record and associate it with this box.
    def attach_uploaded_images
      Array(uploaded_images_params).each do |uploaded_file|
        image = Image.create(data: uploaded_file.read, content_type: uploaded_file.content_type)
        BoxImage.create(box: @box, image: image)
      end
    end

    # Remove images that were marked for deletion
    def remove_marked_images
      image_ids = box_params[:remove_image_ids].reject(&:blank?)
      images_to_remove = Image.where(id: image_ids)
      @box.images.delete(images_to_remove)
    end

    # Assign box to a single group (replacing any existing group assignments)
    def assign_box_group
      group_id = box_params[:box_group_ids]
      if group_id.present?
        @box.box_group_ids = [group_id]
      else
        @box.box_group_ids = []
      end
    end
end
