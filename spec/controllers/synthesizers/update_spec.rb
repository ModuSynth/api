RSpec.describe 'PUT /:id' do
  def app
    Modusynth::Controllers::Synthesizers
  end

  let!(:account) { create(:account) }
  let!(:session) { create(:session, account:) }
  let!(:synthesizer) { create(:synthesizer, account:) }

  describe 'Nominal case' do
    describe 'When nothing is updated' do
      before do
        put("/#{synthesizer.id.to_s}", { auth_token: session.token })
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          name: 'test synth',
          slots: 50, racks: 1,
          voices: 1,
          scale: 1.0, x: 0, y: 0
        )
      end
      describe 'The updated synthesizer' do
        before do
          synthesizer.reload
        end
        it 'Has the correct name' do
          expect(synthesizer.name).to eq 'test synth'
        end
        it 'Has the correct number of slots' do
          expect(synthesizer.slots).to be 50
        end
        it 'Has the correct number of racks' do
          expect(synthesizer.racks).to be 1
        end
        it 'Has the correct X coordinate' do
          expect(synthesizer.x).to be 0
        end
        it 'Has the correct Y coordinate' do
          expect(synthesizer.y).to be 0
        end
        it 'Has the correct scale' do
          expect(synthesizer.scale).to be 1.0
        end
        it 'Has the correct number of polyphony voices' do
          expect(synthesizer.voices).to be 1
        end
      end
    end
  end

  describe 'Alternative cases' do
    describe 'When updating the name' do
      before do
        put "/#{synthesizer.id.to_s}", {
          auth_token: session.token,
          name: 'new name'
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(name: 'new name')
      end
      it 'Has updated the name correctly' do
        synthesizer.reload
        expect(synthesizer.name).to eq 'new name'
      end
    end
    describe 'When updating the number of slots' do
      before do
        put "/#{synthesizer.id.to_s}", {
          auth_token: session.token,
          slots: 100
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(slots: 100)
      end
      it 'Has updated the name correctly' do
        synthesizer.reload
        expect(synthesizer.slots).to be 100
      end
    end
    describe 'When updating the number of racks' do
      before do
        put "/#{synthesizer.id.to_s}", {
          auth_token: session.token,
          racks: 2
        }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(racks: 2)
      end
      it 'Has updated the name correctly' do
        synthesizer.reload
        expect(synthesizer.racks).to be 2
      end
    end
    describe 'When updating the X coordinate' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, x: 100 }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(x: 100)
      end
      it 'Has updated the name correctly' do
        synthesizer.reload
        expect(synthesizer.x).to be 100
      end
    end
    describe 'When updating the Y coordinate' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, y: 100 }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(y: 100)
      end
      it 'Has updated the name correctly' do
        synthesizer.reload
        expect(synthesizer.y).to be 100
      end
    end
    describe 'When updating the scale' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, scale: 2 }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(scale: 2.0)
      end
      it 'Has updated the name correctly' do
        synthesizer.reload
        expect(synthesizer.scale).to be 2.0
      end
    end
    describe 'When updating the number of polyphony voices' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, voices: 64 }
      end
      it 'Returns a 200 (OK) status code' do
        expect(last_response.status).to be 200
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(voices: 64)
      end
      it 'Has updated the name correctly' do
        synthesizer.reload
        expect(synthesizer.voices).to be 64
      end
    end
  end

  describe 'Error cases' do
    describe 'When the synthesizer is not found' do
      before do
        put '/unknown', { auth_token: session.token }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 404
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'id', message: 'unknown'
        )
      end
    end
    describe 'When the name is nil' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, name: nil }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'required'
        )
      end
      it 'Has not updated the name of the synthesizer' do
        synthesizer.reload
        expect(synthesizer.name).to eq 'test synth'
      end
    end
    describe 'When the name is too short' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, name: 'a' }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'name', message: 'length'
        )
      end
      it 'Has not updated the name of the synthesizer' do
        synthesizer.reload
        expect(synthesizer.name).to eq 'test synth'
      end
    end
    describe 'When the number of slots is to low' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, slots: 0 }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'slots', message: 'value'
        )
      end
      it 'Has not updated the slots of the synthesizer' do
        synthesizer.reload
        expect(synthesizer.slots).to be 50
      end
    end
    describe 'When the number of racks is too low' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, racks: 0 }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'racks', message: 'value'
        )
      end
      it 'Has not updated the racks of the synthesizer' do
        synthesizer.reload
        expect(synthesizer.racks).to be 1
      end
    end
    describe 'When the scale is too low' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, scale: 0 }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'scale', message: 'value'
        )
      end
      it 'Has not updated the scale of the synthesizer' do
        synthesizer.reload
        expect(synthesizer.scale).to be 1.0
      end
    end
    describe 'When the number of voices is too low' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, voices: 0 }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'voices', message: 'value'
        )
      end
      it 'Has not updated the scale of the synthesizer' do
        synthesizer.reload
        expect(synthesizer.voices).to be 1
      end
    end
    describe 'When the number of voices is too high' do
      before do
        put "/#{synthesizer.id.to_s}", { auth_token: session.token, voices: 257 }
      end
      it 'Returns a 400 (Bad Request) status code' do
        expect(last_response.status).to be 400
      end
      it 'Returns the correct body' do
        expect(last_response.body).to include_json(
          key: 'voices', message: 'value'
        )
      end
      it 'Has not updated the scale of the synthesizer' do
        synthesizer.reload
        expect(synthesizer.voices).to be 1
      end
    end 
  end
end