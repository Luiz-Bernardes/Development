# BR COBRANÇA - https://github.com/kivanio/brcobranca_exemplo

# gemfiles
gem "rghost"
gem "rghost_barcode"
gem "parseline"
gem "brcobranca", :git => "git://github.com/kivanio/brcobranca.git", :branch => "master"

gem 'nprogress-rails'
gem 'sprockets', '>= 3.0.0'
gem 'sprockets-es6'
gem 'react-rails'
gem 'maskedinput-rails'
gem 'momentjs-rails'


# controller
def gerar_boleto
  @boleto = Brcobranca::Boleto::Caixa.new

  @boleto.cedente = "Kivanio Barbosa"
  @boleto.documento_cedente = "12345678912"
  @boleto.sacado = "Claudio Pozzebom"
  @boleto.sacado_documento = "12345678900"
  @boleto.avalista = "Kivanio Barbosa"
  @boleto.avalista_documento = "12345678912"
  @boleto.valor = 11135.00
  @boleto.agencia = "4042"
  @boleto.conta_corrente = "61900"
  @boleto.variacao = "19"
  @boleto.convenio = "100000"

  @boleto.numero_documento = "111"
  @boleto.data_vencimento = "2008-02-01".to_date
  @boleto.data_documento = "2008-02-01".to_date
  @boleto.instrucao1 = "Pagável na rede bancária até a data de vencimento."
  @boleto.instrucao2 = "Juros de mora de 2.0% mensal(R$ 0,09 ao dia)"
  @boleto.instrucao3 = "DESCONTO DE R$ 29,50 APÓS 05/11/2006 ATÉ 15/11/2006"
  @boleto.instrucao4 = "NÃO RECEBER APÓS 15/11/2006"
  @boleto.instrucao5 = "Após vencimento pagável somente nas agências do Banco do Brasil"
  @boleto.instrucao6 = "ACRESCER R$ 4,00 REFERENTE AO BOLETO BANCÁRIO"
  @boleto.sacado_endereco = "Av. Rubéns de Mendonça, 157 - 78008-000 - Cuiabá/MT"

  headers['Content-Type'] = 'application/pdf'
  send_data @boleto.to(:pdf), :filename => "boleto_caixa.pdf"
end


# index.html.slim
= render partial: "caixa"


# _caixa.html.slim
.post-19.post
  .postheader
    .posttitle
      h2
        a href="http://www.caixa.com.br" target="_blank" CAIXA 104
  .postcontent
    = render :partial => "form", :locals => { banco: 'caixa' }

# _form.html.slim
fieldset
  br
  legend Geração do Boleto
  = form_for "boleto", url: "/home/gerar_boleto/"  do
    = submit_tag 'Gerar'
  end
