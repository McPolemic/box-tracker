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
    if @box.update(box_params.except(:uploaded_images))
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
      params.require(:box).permit(:display_name, :contents, { uploaded_images: [] })
    end

    # For each uploaded file, create an Image record and associate it with this box.
    def attach_uploaded_images
      Array(box_params[:uploaded_images]).each do |uploaded_file|
        image = Image.create(data: uploaded_file.read, content_type: uploaded_file.content_type)
        BoxImage.create(box: @box, image: image)
      end
    end
end
