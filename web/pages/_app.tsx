import type { AppProps } from 'next/app'
import 'bootstrap/dist/css/bootstrap.min.css'
import { createBrowserClient } from '../lib/graphql-client'
import { ApolloProvider } from '@apollo/client'

const App = ({ Component, pageProps }: AppProps) => {
  const client = createBrowserClient(pageProps['Starlight-CSRF-Token'])

  return (
    <ApolloProvider client={client}>
      <Component {...pageProps} />
    </ApolloProvider>
  )
}

export default App
