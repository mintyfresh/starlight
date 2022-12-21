# frozen_string_literal: true

Rails.application.routes.draw do
  get '/.well-known/webfinger', to: 'webfinger#show'

  post '/graphql', to: 'graphql#execute'
end
