# app/views/clients/shared/_form
= f.input :kind, collection: t('clients.kind').invert, prompt: true

# config/locales/clients/pt-BR.yml
---
pt-BR:
  clients:
    kind:
      individual_person: Pessoa Física
      juridical_person: Pessoa Jurídica
