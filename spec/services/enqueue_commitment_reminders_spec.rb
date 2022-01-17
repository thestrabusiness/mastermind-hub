# # frozen_string_literal: true
#
# require "rails_helper"
#
# RSpec.describe EnqueueCommitmentReminders do
#   describe "perform" do
#     context "when a call has a single commitment" do
#       it "enqueues the reminder emails" do
#         call = create(:call)
#         create(:commitment,
#                call: call,
#                membership: create(:membership, group: call.group))
#
#         expect do
#           EnqueueCommitmentReminders.perform(call)
#         end.to change { Delayed::Job.count }.by(2)
#       end
#     end
#
#     context "when the call already has a commitment" do
#       it "does not enqueue the reminder emails" do
#         call = create(:call)
#         create(:commitment,
#                call: call,
#                membership: create(:membership, group: call.group))
#         create(:commitment,
#                call: call,
#                membership: create(:membership, group: call.group))
#
#         expect do
#           EnqueueCommitmentReminders.perform(call)
#         end.to_not(change { Delayed::Job.count })
#       end
#     end
#   end
# end
