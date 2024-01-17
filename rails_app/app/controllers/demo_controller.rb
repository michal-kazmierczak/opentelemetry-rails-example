require './lib/vegetables_set'
require 'net/http'

class DemoController < ApplicationController
  def ping
    render json: { message: 'Pong!' }
  end

  def database_bulk_read
    @vegetables = Vegetable.all.to_a

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @vegetables }
    end
  end

  def database_sequential_read
    vegetables_count = Vegetable.count

    @vegetables = vegetables_count.times.map do |i|
      Vegetable.offset(i).first
    end

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @vegetables }
    end
  end

  def database_bulk_insert
    Vegetable.insert_all(VegetablesSet)

    render json: { message: 'ok!' }
  end

  def database_sequential_insert
    VegetablesSet.each do |vegetable|
      Vegetable.insert(vegetable)
    end

    render json: { message: 'ok!' }
  end

  def database_delete_all
    Vegetable.delete_all

    render json: { message: 'ok!' }
  end

  def remote_http_call
    uri = URI("https://httpbin.org/status/200")
    Net::HTTP.get(uri)

    render json: { message: 'ok!' }
  end

  def increment_own_metric
    tags = {
      method_name: :increment_own_metric
    }
    StatsD.increment('my_own_metric', tags: tags)

    render json: { message: 'ok!' }
  end

  def perform_async_job
    BusyJob.perform_async

    render json: { message: 'ok!' }
  end
end
