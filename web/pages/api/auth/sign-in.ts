import { gql } from '@apollo/client'
import type { NextApiRequest, NextApiResponse } from 'next'
import { validateCSRFToken } from '../../../lib/csrf'
import { SignInMutation } from '../../../lib/generated/graphql'
import { createServerSideClient } from '../../../lib/graphql-client'

const SIGN_IN_MUTATION = gql`
  mutation SignIn($input: SignInInput!) {
    signIn(input: $input) {
      user {
        id
        displayName
      }
      session {
        token
        expiresAt
      }
      errors {
        attribute
        message(full: true)
      }
    }
  }
`

const handler = async (
  req: NextApiRequest,
  res: NextApiResponse<SignInMutation | { errors: readonly any[] }>
) => {
  if (req.method !== 'POST') {
    return res
      .setHeader('Allow', ['POST'])
      .status(405)
      .end('Method Not Allowed')
  }

  const token  = req.cookies['Starlight-Session-Token']
  const client = createServerSideClient(token)

  const { data, errors } = await client.mutate<SignInMutation>({
    mutation: SIGN_IN_MUTATION,
    variables: { input: req.body },
    fetchPolicy: 'no-cache'
  })

  if (errors) {
    return res
      .status(400)
      .json({ errors })
  }

  if (data?.signIn?.errors?.length) {
    return res
      .status(422)
      .json({ signIn: { errors: data.signIn.errors } })
  }

  if (!data || !data.signIn?.session) {
    return res
      .status(500)
      .end('Internal Server Error')
  }

  const expiresAt = new Date(data.signIn.session.expiresAt)
  const maxAge    = Math.floor((expiresAt.getTime() - Date.now()) / 1000)

  return res
    .setHeader(
      'Set-Cookie',
      `Starlight-Session-Token=${data.signIn.session.token}; ` +
      `Secure; Path=/; HttpOnly; SameSite=Lax; Max-Age=${maxAge}`,
    )
    .status(200)
    .json({ signIn: { user: data.signIn.user } })
}

export default validateCSRFToken(handler)
