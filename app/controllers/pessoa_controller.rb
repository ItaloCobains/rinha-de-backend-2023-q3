class PessoaController < ApplicationController
  def contagem_pessoas
    contagem = Pessoa.count
    render plain: contagem.to_s
  end

  def index
    termo = params[:t]
    return render json: { error: "Parâmetro de busca 't' é obrigatório" }, status: :bad_request if termo.blank?

    query = termo.split.map { |t| t.gsub(/['?\\]/, "") }.join(" & ")

    pessoas = Pessoa.where("searchable_text @@ to_tsquery(?)", query).limit(50)
    render json: pessoas
  end

  def show
    pessoa = Pessoa.find_by(id: params[:id])
    if pessoa
      render json: pessoa
    else
      render json: { error: "Pessoa não encontrada" }, status: :not_found
    end
  end

  def create
  body = request.body.read
  begin
    json = JSON.parse(body)

    apelido = json["apelido"]
    nome = json["nome"]
    nascimento_str = json["nascimento"]
    stack = json["stack"] || []

    # Validação básica dos campos
    unless apelido.is_a?(String) && apelido.size <= 32 &&
           nome.is_a?(String) && nome.size <= 100 &&
           nascimento_str.is_a?(String) && nascimento_str.match?(/^\d{4}-\d{2}-\d{2}$/) &&
           (stack.nil? || (stack.is_a?(Array) && stack.all? { |s| s.is_a?(String) && s.size <= 32 }))
      return render json: { error: "Conteúdo inválido" }, status: :unprocessable_entity
    end

    # Converter nascimento para Date
    nascimento = begin
      Date.parse(nascimento_str)
    rescue ArgumentError
      nil
    end

    if nascimento.nil?
      return render json: { error: "Data de nascimento inválida" }, status: :unprocessable_entity
    end

    uuid = SecureRandom.uuid
    now = Time.now.utc

    Pessoa.insert_all!([ {
      id: uuid,
      apelido: apelido,
      nome: nome,
      nascimento: nascimento,
      stack: stack,
      created_at: now,
      updated_at: now
    } ])

    response.headers["Location"] = "/pessoas/#{uuid}"
    render json: { id: uuid, apelido: apelido, nome: nome, nascimento: nascimento_str, stack: stack }, status: :created

  rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
    render json: { error: "Apelido já existente" }, status: :unprocessable_entity
  rescue JSON::ParserError, TypeError
    render json: { error: "Requisição inválida" }, status: :bad_request
  end
end
end
