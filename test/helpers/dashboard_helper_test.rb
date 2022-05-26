# frozen_string_literal: true

require 'test_helper'

class DashboardHelperTest < ActionView::TestCase
  include DashboardHelper

  it 'should show the last deployment details' do
    stubs(:get_revision_details).returns(['abc123', Date.yesterday])
    get_last_deployment.match('https://github.com/blackducksoftware/ohloh-ui/commit/abc123')
  end

  it 'must show details from the REVISION file' do
    commit_sha = ' e2s1sds3 '
    time = Faker::Time.backward
    fyle = stub(read: commit_sha, mtime: time, close: true)
    File.stubs(:open).returns(fyle)

    _(get_revision_details).must_equal [commit_sha.strip, time]
  end

  it 'must return active project count' do
    _(project_count).must_equal Project.active.count
  end

  it 'must return active enlistments project count' do
    _(active_projects_count).must_equal Project.active_enlistments.distinct.size
  end
end
