class License < ActiveRecord::Base
  scope :from_param, ->(id) { where(name: id) }

  acts_as_editable editable_attributes: [:name, :nice_name, :abbreviation, :description, :url],
                   merge_within: 30.minutes
  acts_as_protected

  def to_param
    name
  end

  def allow_undo?(key)
    ![:name, :nice_name].include?(key)
  end

  def allow_edit?
    editor_account && (Account::Access.new(editor_account).admin? || !locked)
  end
end
