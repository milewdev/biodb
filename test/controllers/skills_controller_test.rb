require 'test_helper'

class SkillsControllerTest < ActionController::TestCase
  setup do
    @job = jobs(:one)
    @skill = skills(:one)
  end

  test "should get index" do
    get :index, job_id: @job
    assert_response :success
    assert_not_nil assigns(:job)
    assert_not_nil assigns(:skills)
  end

  test "should get new" do
    get :new, job_id: @job
    assert_response :success
  end

  test "should create skill" do
    assert_difference('Skill.count') do
      post :create, job_id: @job, skill: { group: "a group", job_id: @job, name: "a name" }
    end

    assert_redirected_to job_skill_path(assigns(:job), assigns(:skill))
  end

  test "should show skill" do
    get :show, job_id: @job, id: @skill
    assert_response :success
  end

  test "should get edit" do
    get :edit, job_id: @job, id: @skill
    assert_response :success
  end

  test "should update skill" do
    patch :update, job_id: @job, id: @skill, skill: { group: @skill.group, job_id: @job, name: @skill.name }
    assert_redirected_to job_skill_path(assigns(:job), assigns(:skill))
  end
  
  test "should destroy skill" do
    assert_difference('Skill.count', -1) do
      delete :destroy, id: @skill, job_id: @job
    end

    assert_redirected_to job_skills_path(assigns(:job))
  end
end
