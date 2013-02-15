require 'spec_helper'

describe PaymentsController do
  def valid_paid_params(attrs = {})
    attrs.reverse_merge(
      "id_transacao"=>"942721",
      "valor"=>"290",
      "status_pagamento"=>"4",
      "cod_moip"=>"69862",
      "forma_pagamento"=>"37",
      "tipo_pagamento"=>"CartaoDeCredito",
      "parcelas"=>"1",
      "email_consumidor"=>"bla@foo.com",
      "cartao_bin"=>"471620",
      "cartao_final"=>"0696",
      "cartao_bandeira"=>"Visa",
      "cofre"=>"a6119105-2834-44b3-87ee-ce2c433a69be",
    )
  end
    
  let(:user) { User.make! }
  let(:project) { Project.make! }
  let(:message) { Message.make!(author: user, project: project) }

  before { sign_in user }

  describe "GET 'success_callback'" do
    it "redirects to project" do
      get :success_callback, project_id: project.to_param
      expect(response).to redirect_to(project)
    end
  end

  describe "POST 'notification'" do
    let(:message) { Message.make! }

    before do
      message.save
    end

    context "finished" do
      let(:valid_params) do
        valid_paid_params.merge('id_transacao' => message.payment_token)
      end

      it "confirms the related message" do
        Message.any_instance.should_receive(:confirm!).with(69862)
        post :notification, valid_params
      end

      it "responds with 200 status" do
        post :notification, valid_params
        expect(response.status).to eql(200)
      end
    end
  end
end
