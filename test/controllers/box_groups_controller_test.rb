require "test_helper"

class BoxGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @box_group = box_groups(:one)
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
end
