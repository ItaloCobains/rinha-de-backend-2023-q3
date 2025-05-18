class PessoaController < ApplicationController

  def contagem_pessoas
    @contagem = Pessoa.count

    render json: { contagem: @contagem }
  end

  def index
    search = params[:t]
    if search.present?
      @pessoas = Pessoa.where("apelido ILIKE :search OR nome ILIKE :search OR stack::text ILIKE :search", search: "%#{search}%").limit(50)
    else
      @pessoas = Pessoa.none
    end

    render json: @pessoas
  end

  def show
    @pessoa = Pessoa.find(params[:id])
    render json: @pessoa
  end

  def create
    @pessoa = Pessoa.new(pessoa_params)
    if @pessoa.save
      response.headers['Location'] = pessoa_url(@pessoa)
      render json: @pessoa, status: :created
    else
      render json: @pessoa.errors, status: :unprocessable_entity
    end
  end

  private

  def pessoa_params
    params.require(:pessoa).permit(:apelido, :nome, :nascimento, stack: [])
  end
end
