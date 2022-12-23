import { ApolloClient, InMemoryCache, createHttpLink } from '@apollo/client'
import { setContext } from '@apollo/client/link/context'

export const createBrowserClient = (csrfToken: string) => {
  const httpLink = createHttpLink({
    uri: '/api/graphql'
  })

  const authLink = setContext((_, { headers }) => ({
    headers: {
      ...headers,
      'Starlight-CSRF-Token': csrfToken,
    }
  }))

  return new ApolloClient({
    link: authLink.concat(httpLink),
    cache: new InMemoryCache(),
    credentials: 'same-origin',
    ssrMode: typeof window === 'undefined'
  })
}

export const createServerSideClient = (authToken: string | null | undefined) => {
  const httpLink = createHttpLink({
    uri: process.env.GRAPHQL_API_URL
  })

  const authLink = setContext((_, { headers }) => ({
    headers: {
      ...headers,
      authorization: authToken ? `Starlight ${authToken}` : ''
    }
  }))

  return new ApolloClient({
    link: authLink.concat(httpLink),
    cache: new InMemoryCache(),
    ssrMode: true
  })
}
