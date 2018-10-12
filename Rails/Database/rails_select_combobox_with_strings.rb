# model
KIND = ['Acadêmico', 'Beneficente', 'Cultural', 'Ecológico', 'Esportivo', 'Outro']
# view
= f.input :kind, label: 'Tipo', collection: User::KIND, prompt: 'Selecione o tipo', input_html: { class: 'form-control input-collection'}