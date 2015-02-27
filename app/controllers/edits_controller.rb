class EditsController < ApplicationController
  before_action :find_parent
  before_action :find_edit, only: [:update]
  before_action :find_edits, only: [:index]

  def index
    render template: "edits/index_#{@parent.class.name.downcase}"
  end

  def update
  end

  private

  def find_parent
    @parent = find_account || find_project || find_organization || find_license
    fail ParamRecordNotFound unless @parent
  end

  def find_account
    return nil unless params[:account_id]
    Account.in_good_standing.from_param(params[:account_id]).take
  end

  def find_project
    return nil unless params[:project_id]
    Project.from_param(params[:project_id]).take
  end

  def find_organization
    return nil unless params[:organization_id]
    Organization.from_param(params[:organization_id]).take
  end

  def find_license
    return nil unless params[:license_id]
    License.from_param(params[:license_id]).take
  end

  def find_edit
    @edit = Edit.where(target: @parent, id: params[:id]).first
    fail ParamRecordNotFound unless @edit
  end

  def find_edits
    edits = Edit.page(params[:page]).per_page(10).order('edits.created_at DESC, edits.id DESC')
    @edits = add_query_term(add_robotic_term(add_where_term(edits)))
  end

  def add_where_term(edits)
    target_where = '(edits.target_id = ? AND edits.target_type = ?)'
    extra_where = add_where_extra_clause
    if extra_where
      edits.where(["#{target_where}#{extra_where}", @parent.id, @parent.class.name.tableize, @parent.id])
    else
      edits.where([target_where, @parent.id, @parent.class.name])
    end
  end

  def add_where_extra_clause
    case @parent
    when Account
      ' OR edits.account_id = ?'
    when Project
      ' OR edits.project_id = ?'
    when Organization
      ' OR edits.organization_id = ?'
    end
  end

  def add_robotic_term(edits)
    non_human_ids = params[:human].present? && params[:human] == 'true' ? (Account.non_human_ids) : [0]
    edits.where.not(account_id: non_human_ids)
  end

  def add_query_term(edits)
    query_term = params[:q] || params[:query]
    query_term ? edits.filterable_by(query_term) : edits
  end
end
