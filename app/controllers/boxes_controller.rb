class BoxesController < ApplicationController
  include WriteAuthorization

  before_action :set_box, only: %i[ show edit update destroy ]
  before_action :require_write_access, only: %i[ new create edit update destroy ]

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
    @box = Box.new(box_params.except(:uploaded_images))

    if @box.save
      attach_uploaded_images if box_params[:uploaded_images]
      redirect_to @box, notice: "Box was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /boxes/1
  def update
    if @box.update(box_params.except(:uploaded_images, :remove_image_ids))
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
      params.require(:box).permit(:display_name, :contents, { uploaded_images: [], remove_image_ids: [] })
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
end
