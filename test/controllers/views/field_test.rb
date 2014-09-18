require 'test_helper'


# find('#some_field_id', visible: false) finds visible and hidden elements on the page and 
# we want to be able to find a field whether it is visible or not.
# See: https://github.com/jnicklas/capybara/blob/master/lib/capybara/node/finders.rb#L135
class FieldList
  include Capybara::DSL
  
  Change = ' CHANGE'
  
  def initialize(field_names)
    @field_ids = field_names.map { |field_name| field_name.to_s.dasherize }
  end
  
  def must_be_populated
    @field_ids.each do |field_id|               # TODO: need to DRY this loop from all these methods
      find("##{field_id}", visible: false).text.wont_be_empty
    end
  end
  
  def wont_be_populated
    @field_ids.each do |field_id|
      find("##{field_id}", visible: false).text.must_be_empty
    end
  end
  
  def must_be_editable
    @field_ids.each do |field_id|
      element = find("##{field_id}", visible: false)
      element[:contentEditable].must_equal 'true'
      element[:class].must_include 'edit-mode'
      element[:class].nil? or element[:class].wont_include 'view-mode'
    end
  end
  
  def wont_be_editable
    @field_ids.each do |field_id|
      element = find("##{field_id}", visible: false)
      element[:contentEditable].wont_equal true
      element[:class].must_include 'view-mode'
      element[:class].nil? or element[:class].wont_include 'edit-mode'
    end
  end
  
  def must_be_visible
    @field_ids.each do |field_id|
      element = find("##{field_id}", visible: false)
      element[:class].must_include 'visible'
      element[:class].nil? or element[:class].wont_include 'hidden'
    end
  end
  
  def wont_be_visible
    @field_ids.each do |field_id|
      element = find("##{field_id}", visible: false)
      element[:class].must_include 'hidden'
      element[:class].nil? or element[:class].wont_include 'visible'
    end
  end
  
  def must_exist
    @field_ids.each do |field_id|
      page.must_have_css "##{field_id}"
    end
  end
  
  def wont_exist
    @field_ids.each do |field_id|
      page.wont_have_css "##{field_id}"
    end
  end
  
  def change_text
    @field_ids.each do |field_id|
      find("##{field_id}", visible: false).native.send_keys :End, Change
    end
  end
  
  def must_be_changed
    @field_ids.each do |field_id|
      element = find("##{field_id}", visible: false)
      find("##{field_id}", visible: false).text.must_match( /#{Change}\z/ )
    end
  end
  
  def wont_be_changed
    @field_ids.each do |field_id|
      element = find("##{field_id}", visible: false)
      find("##{field_id}", visible: false).text.wont_match( /#{Change}\z/ )
    end
  end
  
  def delete_text
    @field_ids.each do |field_id|
      element = find("##{field_id}", visible: false)
      # Yep, that's end, and backspace, and backspace, and backspace, and ...
      element.native.send_keys :End, *( Array.new( element.text.length, :Backspace ) )
    end
  end

  # TODO: rethink this; cumbersome that we have to pass in the record
  def must_be_saved_to(record)
    @field_ids.each do |field_id|
      field_name = field_id.underscore.sub(/\A[^_]*_/, '')
      record.send(field_name).must_match( /#{Change}\z/ )
    end
  end
end


class FieldIntegrationTest < ActionDispatch::IntegrationTest

  let(:editable_fields) { FieldList.new( [ :user_name, :user_title, :user_highlights ] ) }
  let(:readonly_fields) { FieldList.new( [ :user_email ] ) }

  describe 'internal check: javascript' do
    specify { Capybara.current_driver.must_equal :poltergeist }
  end

  describe 'internal check: :unpopulated_user' do
    before do
      sign_in :unpopulated_user
    end
    specify { readonly_fields.must_be_populated }
    specify { editable_fields.wont_be_populated }
  end

  describe 'internal check: :generic_user' do
    before do
      sign_in :generic_user
    end
    specify { readonly_fields.must_be_populated }
    specify { editable_fields.must_be_populated }
  end

  describe 'when not signed in' do
    before do
      sign_out
    end
    specify { editable_fields.wont_exist }
    specify { readonly_fields.wont_exist }
  end

  describe 'immediately after signing in' do
    before do
      sign_in :generic_user
    end
    specify { edit_mode_checkbox.checked?.must_equal false }   # TODO: write #must_be_checked
  end

  describe 'users with unpopulated fields in view mode' do
    before do
      sign_in :unpopulated_user
      use_view_mode
    end
    specify { readonly_fields.must_be_visible }
    specify { readonly_fields.wont_be_editable }
    specify { editable_fields.wont_be_visible }
    specify { editable_fields.wont_be_editable }
  end

  describe 'users with unpopulated fields in edit mode' do
    before do
      sign_in :unpopulated_user
      use_edit_mode
    end
    specify { readonly_fields.must_be_visible }
    specify { readonly_fields.wont_be_editable }
    specify { editable_fields.must_be_visible }
    specify { editable_fields.must_be_editable }
  end

  describe 'users with populated fields in view mode' do
    before do
      sign_in :generic_user
      use_view_mode
    end
    specify { readonly_fields.must_be_visible }
    specify { readonly_fields.wont_be_editable }
    specify { editable_fields.must_be_visible }
    specify { editable_fields.wont_be_editable }
  end

  describe 'users with populated fields in edit mode' do
    before do
      sign_in :generic_user
      use_edit_mode
    end
    specify { readonly_fields.must_be_visible }
    specify { readonly_fields.wont_be_editable }
    specify { editable_fields.must_be_visible }
    specify { editable_fields.must_be_editable }
  end

  describe 'users with unpopulated fields, switching back to view mode' do
    before do
      sign_in :unpopulated_user
      use_edit_mode
      use_view_mode
    end
    specify { readonly_fields.must_be_visible }
    specify { readonly_fields.wont_be_editable }
    specify { editable_fields.wont_be_visible }
    specify { editable_fields.wont_be_editable }
  end

  describe 'when first switching to edit mode' do
    before do
      sign_in :generic_user
      use_edit_mode
    end
    specify { save_button.disabled?.must_equal true }     # TODO: write #wont_be_enabled
  end

  describe 'when fields are changed in edit mode' do
    before do
      sign_in :generic_user
      use_edit_mode
      editable_fields.change_text
      readonly_fields.change_text
    end
    specify { editable_fields.must_be_changed }
    specify { readonly_fields.wont_be_changed }
    specify { save_button.disabled?.must_equal false }    # TODO: write #must_be_enabled
  end

  describe 'the contents of fields are deleted, switching back to view mode' do
    before do
      sign_in :generic_user
      use_edit_mode
      editable_fields.delete_text
      use_view_mode
    end
    specify { editable_fields.wont_be_visible }
  end

  describe 'pressing the save button' do
    before do
      sign_in :generic_user
      use_edit_mode
      editable_fields.change_text
      save_button.click
      sleep(0.1)            # TODO: instead, wait for save_button to disable or 'saved' to appear somewhere
    end
    specify { editable_fields.must_be_saved_to User.find(users(:generic_user).id) }
  end

end
