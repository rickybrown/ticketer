class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
  
  respond_to :html, :js

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.order(:number).reverse_order
    
    @tickets = @tickets.by_user_id(params[:user])
      .by_assignee_id(params[:assignee])
      .by_priority(params[:priority])
      .by_status(params[:status])
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
    respond_with(@ticket)
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end
  
  # GET /tickets/express
  def express
    @ticket = Ticket.new
    
    @ticket.status   = 1 # New
    @ticket.priority = 2 # Medium
    @ticket.user_id  = current_user.id
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to tickets_url, notice: 'Ticket was successfully created.' }
        format.json { render :index, status: :created, location: @ticket }
      else
        format.html { render :new }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to tickets_url, notice: 'Ticket was successfully updated.' }
        format.json { render :index, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.require(:ticket).permit(:subject, :content, :status, :priority, :user_id, :assignee_id)
    end
end
