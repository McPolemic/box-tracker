require "test_helper"

class BoxGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @box_group = box_groups(:one)
    authenticate_with_write_access
  end

  test "should get index" do
    get box_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_box_group_url
    assert_response :success
  end

  test "should create box_group" do
    assert_difference("BoxGroup.count") do
      post box_groups_url, params: { box_group: { display_name: @box_group.display_name, notes: @box_group.notes } }
    end

    assert_redirected_to box_group_url(BoxGroup.last)
  end

  test "should show box_group" do
    get box_group_url(@box_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_box_group_url(@box_group)
    assert_response :success
  end

  test "should update box_group" do
    patch box_group_url(@box_group), params: { box_group: { display_name: @box_group.display_name, notes: @box_group.notes } }
    assert_redirected_to box_group_url(@box_group)
  end

  test "should destroy box_group" do
    assert_difference("BoxGroup.count", -1) do
      delete box_group_url(@box_group)
    end

    assert_redirected_to box_groups_url
  end

  test "should block new without authentication" do
    cookies[:write_access] = nil
    get new_box_group_url
    assert_response :unauthorized
  end

  test "should block create without authentication" do
    cookies[:write_access] = nil
    assert_no_difference("BoxGroup.count") do
      post box_groups_url, params: { box_group: { display_name: "Test Group", notes: "Some notes" } }
    end
    assert_response :unauthorized
  end

  test "should block edit without authentication" do
    cookies[:write_access] = nil
    get edit_box_group_url(@box_group)
    assert_response :unauthorized
  end

  test "should block update without authentication" do
    cookies[:write_access] = nil
    patch box_group_url(@box_group), params: { box_group: { display_name: "Updated Name" } }
    assert_response :unauthorized
  end

  test "should block destroy without authentication" do
    cookies[:write_access] = nil
    assert_no_difference("BoxGroup.count") do
      delete box_group_url(@box_group)
    end
    assert_response :unauthorized
  end

  test "should block bulk_add without authentication" do
    cookies[:write_access] = nil
    box = boxes(:one)
    post bulk_add_box_groups_url, params: { box_ids: [box.id], group_option: "existing_#{@box_group.id}" }
    assert_response :unauthorized
  end

  test "should block add_box without authentication" do
    cookies[:write_access] = nil
    box = boxes(:one)
    post add_box_box_group_url(@box_group), params: { box_id: box.id }
    assert_response :unauthorized
  end

  test "should block remove_box without authentication" do
    cookies[:write_access] = nil
    box = boxes(:one)
    @box_group.boxes << box
    delete remove_box_box_group_url(@box_group), params: { box_id: box.id }
    assert_response :unauthorized
  end
end
