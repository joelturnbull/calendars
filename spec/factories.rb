FactoryGirl.define do
  factory :event do
    sequence :ics do |n|
      "BEGIN:VEVENT\nSEQUENCE:1\nDESCRIPTION:Tweens#{n}\nURL;VALUE=URI:http://cincymusic.com/shows/2012/10/tweens2\nSUMMARY:Tweens\nLOCATION:The Comet\\n4579 Hamilton Avenue\\nCincinnati, Cincinnati 45223\nUID:b9d06666d7172070176d8a49e847304e@cincymusic.com\nDTSTART;TZID=US/Eastern:20121030T220000\nDTSTAMP:20121027T143347\nDTEND;TZID=US/Eastern:20121031T010000\nEND:VEVENT\n"
    end
  end
end
