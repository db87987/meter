class InstancesController < ApplicationController
  def index
    instances = Instance.all
    render json: instances
  end

  def create
    instance = Instance.create(permitted_params)
    if instance.save
      render json: instance
    else
      render json: { errors: instance.errors }
    end
  end

  def destroy
    instance = Instance.find(params[:id])
    instance.destroy
    render plain: 'Instance Successfully Destroyed'
  end

  def statistics
    instance = Instance.find_by(ip: params[:ip])
    from = Time.parse(params[:from])
    to = Time.parse(params[:to])
    statistics = instance.statistics(from, to)
    render json: statistics
  end

  def permitted_params
    params.permit(:ip)
  end
end