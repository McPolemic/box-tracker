require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @valid_params = { display_name: "Test Group", notes: "Some notes" }
    # Depending on your validations, you could set up invalid params.
    # With no validations on Group, these will succeed unless you stub.
    @invalid_params = { display_name: "", notes: "" }
  end

  # --- INDEX ---
  test "should get index in html" do
    get groups_url
    assert_response :success
  end

  test "should get index in json" do
    get groups_url(format: :json)
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_kind_of Array, json_response
  end

  # --- NEW ---
  test "should get new" do
    get new_group_url
    assert_response :success
  end

  # --- CREATE ---
  test "should create group in html" do
    assert_difference("Group.count") do
      post groups_url, params: { group: @valid_params }
    end

    assert_redirected_to group_url(Group.last)
  end

  test "should create group in json" do
    assert_difference("Group.count") do
      post groups_url(format: :json), params: { group: @valid_params }
    end

    assert_response :created
    json_response = JSON.parse(@response.body)
    assert_equal @valid_params[:display_name], json_response["display_name"]
  end

  test "should render new when create fails in html" do
    # Force failure by stubbing save to return false
    Group.any_instance.stub(:save, false) do
      post groups_url, params: { group: @valid_params }
      assert_response :unprocessable_entity
    end
  end

  test "should render errors when create fails in json" do
    Group.any_instance.stub(:save, false) do
      post groups_url(format: :json), params: { group: @valid_params }
      assert_response :unprocessable_entity
      json_response = JSON.parse(@response.body)
      # Expect some error messages; adjust assertions to match your error structure.
      assert_not_empty json_response
    end
  end

  # --- SHOW ---
  test "should show group in html" do
    get group_url(@group)
    assert_response :success
  end

  test "should show group in json" do
    get group_url(@group, format: :json)
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal @group.display_name, json_response["display_name"]
  end

  # --- EDIT ---
  test "should get edit" do
    get edit_group_url(@group)
    assert_response :success
  end

  # --- UPDATE ---
  test "should update group in html" do
    patch group_url(@group), params: { group: @valid_params }
    assert_redirected_to group_url(@group)
  end

  test "should update group in json" do
    patch group_url(@group, format: :json), params: { group: @valid_params }
    assert_response :ok
    json_response = JSON.parse(@response.body)
    assert_equal @valid_params[:display_name], json_response["display_name"]
  end

  test "should render edit when update fails in html" do
    Group.any_instance.stub(:update, false) do
      patch group_url(@group), params: { group: @valid_params }
      assert_response :unprocessable_entity
    end
  end

  test "should render errors when update fails in json" do
    Group.any_instance.stub(:update, false) do
      patch group_url(@group, format: :json), params: { group: @valid_params }
      assert_response :unprocessable_entity
      json_response = JSON.parse(@response.body)
      assert_not_empty json_response
    end
  end

  # --- DESTROY ---
  test "should destroy group in html" do
    assert_difference("Group.count", -1) do
      delete group_url(@group)
    end

    assert_redirected_to groups_url
  end

  test "should destroy group in json" do
    assert_difference("Group.count", -1) do
      delete group_url(@group, format: :json)
    end

    assert_response :no_content
  end
end