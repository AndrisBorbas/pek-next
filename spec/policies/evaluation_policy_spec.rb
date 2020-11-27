RSpec.describe EvaluationPolicy, type: :policy do
  subject { described_class.new(user, evaluation) }

  let(:evaluation)              { create(:evaluation) }
  let(:evaluation_actions)      { %i[show current table edit update] }
  let(:evaluation_view_actions) { evaluation_actions - %i[edit update] }
  let(:point_request_actions)   { %i[submit_point_request cancel_point_request] }
  let(:entry_request_actions)   { %i[submit_entry_request cancel_entry_request] }
  let(:submit_actions)          { %i[submit_point_request submit_entry_request] }
  let(:cancel_actions)          { %i[cancel_point_request cancel_entry_request] }
  let(:all_action)              { entry_request_actions + point_request_actions + entry_request_actions }

  context 'when application season' do
    include_context 'application season'

    context 'and the user is the group leader' do
      let(:user) { evaluation.group.leader.user }

      it { is_expected.to permit_actions(all_action - cancel_actions) }
      it { is_expected.to forbid_actions(cancel_actions) }

      context "and the request is submitted" do
        before(:each) do
          evaluation.point_request_status = Evaluation::NOT_YET_ASSESSED
          evaluation.entry_request_status = Evaluation::NOT_YET_ASSESSED
        end

        it { is_expected.to permit_actions(cancel_actions) }
        it { is_expected.to forbid_actions(submit_actions) }
      end
    end

    context "and the user is the evaluation helper of the group" do
      let(:user) do
        evaluation.group.memberships.select(&:evaluation_helper?).first.user
      end

      it { is_expected.to permit_actions(all_action - cancel_actions) }
      it { is_expected.to forbid_actions(cancel_actions) }
    end

    context 'and the user is a leader of another the group' do
      let(:user) { create(:group).leader.user }

      it { is_expected.to forbid_actions(all_action) }
    end

    context 'and the user is a leader of another group in the resort' do
      let(:user) { evaluation.group.parent.children.select{ |g| g != evaluation.group }.first.leader.user }

      it { is_expected.to  permit_actions(evaluation_view_actions) }
      it { is_expected.to  forbid_actions(all_action - evaluation_view_actions) }
    end

    context 'and the group has no parents' do
      let(:user) { create(:user) }

      before(:each) do
        evaluation.group.update(parent: nil)
      end

      it { is_expected.to forbid_actions(all_action) }
    end

    context 'and the user is the leader of the group resort' do
      let(:user) { evaluation.group.parent.leader.user }

      it { is_expected.to permit_actions(evaluation_view_actions) }
      it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }
    end
  end

  context 'when evaluation season' do
    include_context 'evaluation season'

    context "and the user is the group leader" do
      let(:user) { evaluation.group.leader.user }

      it { is_expected.to permit_actions(evaluation_view_actions) }
      it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }

      context "and the point request is rejected" do
        before { evaluation.point_request_status = Evaluation::REJECTED }

        it { is_expected.to permit_actions(point_request_actions - cancel_actions) }
      end

      context "when the entry_request is rejected" do
        before { evaluation.entry_request_status = Evaluation::REJECTED }

        it { is_expected.to permit_actions(entry_request_actions - cancel_actions) }
      end
    end

    context "when the user is the resort leader" do
      let(:user) { evaluation.group.parent.leader.user }

      it { is_expected.to permit_actions(all_action - cancel_actions) }

      context "and the point and entry request is accepted" do
        before do
          evaluation.point_request_status = Evaluation::ACCEPTED
          evaluation.entry_request_status = Evaluation::ACCEPTED
        end

        it { is_expected.to forbid_actions(all_action - evaluation_view_actions) }
      end
    end
  end

  context 'off season' do
    include_context 'off season'
    let(:user) { evaluation.group.leader.user }

    it { is_expected.to forbid_actions(all_action) }
  end
end