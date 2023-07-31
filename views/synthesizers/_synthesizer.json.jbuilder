json.id membership.synthesizer.id.to_s
json.(membership.synthesizer, :name, :slots, :racks, :voices)
json.(membership, :x, :y, :scale)
json.creator do
  json.username membership.synthesizer.creator.account.username
  json.id membership.synthesizer.creator.account.id.to_s
end
json.members do
  json.array! membership.synthesizer.guests do |m|
    json.id m.id.to_s
    json.account_id m.account.id.to_s
    json.username m.account.username
    json.type m.type.to_s
  end
end