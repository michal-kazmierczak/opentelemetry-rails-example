require "rails_helper"

describe "DemoController", type: :request do
  describe "#ping" do
    subject { get "/demo/ping" }

    it "works" do
      subject

      expect(response).to have_http_status 200
      expect(response.body).to eq({ message: 'Pong!' }.to_json)
    end
  end

  describe "#database_bulk_read" do
    context "when accepting json response" do
      subject do
        get "/demo/database_bulk_read", headers: { accept: 'application/json' }
      end

      it "renders HTTP code 200" do
        subject

        expect(response).to have_http_status 200
      end

      it "responds with JSON body" do
        subject

        expect(response.headers['Content-Type']).to match /application\/json/
      end
    end

    context "when accepting html response" do
      subject do
        get "/demo/database_bulk_read", headers: { accept: 'text/html' }
      end

      it "renders HTTP code 200" do
        subject

        expect(response).to have_http_status 200
      end

      it "responds with HTML" do
        subject

        expect(response.headers['Content-Type']).to match /text\/html/
      end
    end
  end

  describe "#database_sequential_read" do
    context "when accepting json response" do
      subject do
        get "/demo/database_sequential_read", headers: { accept: 'application/json' }
      end

      it "renders HTTP code 200" do
        subject

        expect(response).to have_http_status 200
      end

      it "responds with JSON body" do
        subject

        expect(response.headers['Content-Type']).to match /application\/json/
      end
    end

    context "when accepting html response" do
      subject do
        get "/demo/database_sequential_read", headers: { accept: 'text/html' }
      end

      it "renders HTTP code 200" do
        subject

        expect(response).to have_http_status 200
      end

      it "responds with HTML" do
        subject

        expect(response.headers['Content-Type']).to match /text\/html/
      end
    end
  end

  describe "#database_bulk_insert" do
    subject do
      get "/demo/database_bulk_insert"
    end

    it "renders HTTP code 200" do
      subject

      expect(response).to have_http_status 200
    end

    it "inserts into database" do
      expect{ subject }.to change{ Vegetable.count }
    end
  end

  describe "#database_sequential_insert" do
    subject do
      get "/demo/database_sequential_insert"
    end

    it "renders HTTP code 200" do
      subject

      expect(response).to have_http_status 200
    end

    it "inserts into database" do
      expect{ subject }.to change{ Vegetable.count }
    end
  end

  describe "#database_delete_all" do
    subject do
      get "/demo/database_delete_all"
    end

    it "renders HTTP code 200" do
      subject

      expect(response).to have_http_status 200
    end

    it "wipes the database" do
      subject
      expect(Vegetable.count).to eq 0
    end
  end

  describe "#remote_http_call" do
    subject do
      get "/demo/remote_http_call"
    end

    before do
      stub_request(:get, "https://httpbin.org/status/200")
    end

    it "renders HTTP code 200" do
      subject

      expect(response).to have_http_status 200
    end
  end

  describe "#increment_own_metric" do
    subject do
      get "/demo/increment_own_metric"
    end

    it "renders HTTP code 200" do
      subject

      expect(response).to have_http_status 200
    end

    it "increments the counter" do
      expect(StatsD).to receive(:increment)
      subject
    end
  end

  describe "#perform_async_job" do
    subject do
      get "/demo/perform_async_job"
    end

    it "renders HTTP code 200" do
      subject

      expect(response).to have_http_status 200
    end

    it "schedules async execution" do
      expect(BusyJob).to receive(:perform_async)
      subject
    end
  end
end
