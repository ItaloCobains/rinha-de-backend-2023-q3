class PessoaController < ApplicationController
  def contagem_pessoas
    @contagem = Pessoa.count

    render plain: @contagem.to_s
  end

  def index
    search = params[:t]
    return render json: { error: "Parâmetro de busca 't' é obrigatório" }, status: :bad_request if search.blank?

    @pessoas = Pessoa.where("searchable_text ILIKE ?", "%#{search}%").limit(50)

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
      response.headers["Location"] = "/pessoas/#{@pessoa.id}"
      render json: @pessoa, status: :created
    else
      render json: { error: @pessoa.errors }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing, JSON::ParserError
    render json: { error: "Requisição inválida" }, status: :bad_request
  rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
    render json: { error: "Apelido já existente" }, status: :unprocessable_entity and return
  end

  private

  def pessoa_params
    params.require(:pessoa).permit(:apelido, :nome, :nascimento, stack: [])
  end
end
