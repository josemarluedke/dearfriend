class MessagesController < ApplicationController
  inherit_resources
  respond_to :html, :json
  actions :new, :create, :update

  def new
    new!
  end

  def update
    update! do
      if resource.letter_with_project?
        redirect_to action: :confirm_payment
      elsif resource.complete_letter?
        redirect_to action: :select_project
      else
        render :new
      end
    end
  end

  def select_project
  end

  def confirm_payment
  end
end
