#Send Notifications daily
every 1.day, at: '8:00 am' do
  rake 'notifications:send:unsent'
end
