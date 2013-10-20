require 'spec_helper'

describe Room do
  describe '#first_not_full' do
    it 'should return not full room' do
      r1 = create(:room, users_count: Room::ROOM_SIZE)
      create(:room_question, room: r1)
      r2 = create(:room)
      create(:room_question, room: r2)
      Room.first_not_full.should eql(r2)
    end

    it 'should create new room if all are full' do
      r1 = create(:room, users_count: Room::ROOM_SIZE)
      create(:room_question, room: r1)
      expect {
        Room.first_not_full.name.should eql('Room 2')
      }.to change(Room, :count).from(1).to(2)
    end

    it 'should not return full rooms' do
      r1 = create(:room)
      create(:room_question, room: r1, winner: create(:user))
      expect {
        Room.first_not_full.name.should eql('Room 2')
      }.to change(Room, :count).from(1).to(2)
    end
  end
end
