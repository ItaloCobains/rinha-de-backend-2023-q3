class PessoaController < ApplicationController
  def contagem_pessoas
    @contagem = Pessoa.count

    render plain: @contagem.to_s
  end

  def index
    search = params[:t]
    
    if search.blank?
      return render json: { error: "Parâmetro de busca 't' é obrigatório" }, status: :bad_request
    end
    
    search_term = "%#{search}%"
    
    @pessoas = Pessoa
      .where("apelido ILIKE :search OR nome ILIKE :search", search: search_term)
      .or(
        Pessoa.where("exists(select 1 from jsonb_array_elements_text(stack) as elem where elem ILIKE :search)", search: search_term)
      )
      .limit(50)
  
    render json: @pessoas
  end
  

  def show
    @pessoa = Pessoa.find_by(id: params[:id])
    
    if @pessoa
      render json: @pessoa
    else
      render json: { error: "Pessoa não encontrada" }, status: :not_found
    end
  end

  def create
    @pessoa = Pessoa.new(pessoa_params)
    
    if @pessoa.save
      response.headers['Location'] = "/pessoas/#{@pessoa.id}"
      render json: @pessoa, status: :created
    else
      if @pessoa.errors.include?(:apelido) && Pessoa.exists?(apelido: params[:pessoa][:apelido])
        render json: { error: "Apelido já existente" }, status: :unprocessable_entity
      else
        render json: { error: @pessoa.errors }, status: :unprocessable_entity
      end
    end
  rescue ActionController::ParameterMissing, JSON::ParserError => e
    render json: { error: "Requisição inválida" }, status: :bad_request
  end

  private

  def pessoa_params
    params.require(:pessoa).permit(:apelido, :nome, :nascimento, stack: [])
  end
end