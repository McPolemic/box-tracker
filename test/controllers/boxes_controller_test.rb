require "test_helper"

class BoxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @box = boxes(:one)
    # Use fixture_file_upload from ActiveSupport::TestCase
    @uploaded_file = fixture_file_upload("test_image.png", "image/png")
  end

  test "should get index" do
    get boxes_url
    assert_response :success
    # Optionally check that both @boxes and @box_groups are assigned in the view:
    assert_select "h1", "Boxes"
  end

  test "should get new" do
    get new_box_url
    assert_response :success
  end

  test "should create box without images" do
    assert_difference("Box.count", 1) do
      post boxes_url, params: { box: { display_name: "Test Box", contents: "Some contents" } }
    end

    assert_redirected_to box_url(Box.last)
    follow_redirect!
    assert_response :success
    assert_match "Box was successfully created.", response.body
  end

  test "should create box with uploaded images" do
    assert_difference("Box.count", 1) do
      # Expect an Image and BoxImage to be created for the uploaded file.
      assert_difference("Image.count", 1) do
        assert_difference("BoxImage.count", 1) do
          post boxes_url, params: { box: {
            display_name: "Box with Image",
            contents: "Content with image",
            uploaded_images: [ @uploaded_file ]
          } }
        end
      end
    end

    box = Box.last
    assert box.images.any?, "Expected the box to have attached images"
    assert_redirected_to box_url(box)
    follow_redirect!
    assert_response :success
    assert_match "Box was successfully created.", response.body
  end

  test "should show box" do
    get box_url(@box)
    assert_response :success
    assert_select "section#box-details" do
      assert_select "p", /Display Name:/
      assert_select "div", /Contents:/
    end
  end

  test "should get edit" do
    get edit_box_url(@box)
    assert_response :success
  end

  test "should update box without images" do
    new_display_name = "Updated Name"
    new_contents = "Updated Contents"
    patch box_url(@box), params: { box: { display_name: new_display_name, contents: new_contents } }
    assert_redirected_to box_url(@box)
    @box.reload
    assert_equal new_display_name, @box.display_name
    assert_equal new_contents, @box.contents
  end

  test "should update box with uploaded images" do
    # Clear any existing images for a clean update test
    @box.images.destroy_all
    assert_equal 0, @box.images.count

    patch box_url(@box), params: { box: {
      display_name: @box.display_name,
      contents: @box.contents,
      uploaded_images: [ @uploaded_file ]
    } }
    assert_redirected_to box_url(@box)
    @box.reload
    assert @box.images.any?, "Expected at least one image after update with file upload"
  end

  test "should destroy box" do
    assert_difference("Box.count", -1) do
      delete box_url(@box)
    end
    assert_redirected_to boxes_url
  end
end
