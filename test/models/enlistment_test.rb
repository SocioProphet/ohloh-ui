require 'test_helper'

class EnlistmentTest < ActiveSupport::TestCase
  let(:enlistment) { create(:enlistment) }
  let(:fyle) { create(:fyle) }

  describe 'ignore_examples' do
    it 'should return empty array' do
      enlistment.ignore_examples.must_equal nil
    end

    it 'should return fyles' do
      enlistment.repository.best_code_set_id = fyle.code_set_id
      enlistment.ignore_examples.count.must_equal 1
      enlistment.ignore_examples.first.must_equal fyle.name
    end
  end

  describe 'analysis_sloc_set' do
    it 'should return nil if best_analysis is nil' do
      enlistment.analysis_sloc_set.must_equal nil
    end

    it 'should return analysis_sloc_set' do
      analysis_sloc_set = create(:analysis_sloc_set, analysis: enlistment.project.best_analysis)
      enlistment.repository.update(best_code_set_id: analysis_sloc_set.sloc_set.code_set_id)
      enlistment.analysis_sloc_set.must_equal analysis_sloc_set
    end
  end

  describe 'ensure_forge_and_job' do
    it 'should create a new job for project' do
      Repository.any_instance.stubs(:ensure_job).returns(false)

      analysis = create(:analysis, created_at: 2.months.ago)
      project = create(:project)
      project.update_column(:best_analysis_id, analysis.id)
      forge = Forge.find_by(name: 'Github')
      repo = create(:repository, url: 'git://github.com/rails/rails.git', forge_id: forge.id,
                                 owner_at_forge: 'rails', name_at_forge: 'rails')
      enlistment = create(:enlistment, project: project, repository: repo)

      enlistment.ensure_forge_and_job
      project.jobs.count.must_equal 1
    end
  end
end
