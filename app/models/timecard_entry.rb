# == Schema Information
# Schema version: 93
#
# Table name: timecard_entries
#
#  id           :integer(11)     not null, primary key
#  member_id    :integer(11)
#  hours        :float
#  eventdate_id :integer(11)
#  timecard_id  :integer(11)
#  payrate      :float
#

class TimecardEntry < ActiveRecord::Base
	belongs_to :timecard

	belongs_to :member
	belongs_to :eventdate
	validates_presence_of :member_id, :eventdate_id, :hours
	validates_numericality_of :hours, :member_id
	validates_inclusion_of :timecard_id, :in => Timecard.valid_timecards.map {|t| t.id} << nil, :message => 'is invalid'
	validate :eventdate_in_range, :check_submitted
	before_destroy :check_submitted

	attr_protected :member_id

	private
	def eventdate_in_range
		errors.add(:eventdate, 'is invalid') unless timecard.nil? or timecard.valid_eventdates.include? eventdate
	end

	def check_submitted
		return false if !timecard.nil? and timecard.submitted
	end
end
