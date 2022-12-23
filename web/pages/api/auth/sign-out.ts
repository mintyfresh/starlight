import { gql } from '@apollo/client'
import type { NextApiRequest, NextApiResponse } from 'next'
import { createServerSideClient } from '../../../lib/graphql-client'
import { SignOutMutation } from '../../../lib/generated/graphql'

const SIGN_OUT_MUTATION = gql`
  mutation SignOut {
    signOut {
      success
    }
  }
`

const handler = async (
  req: NextApiRequest,
  res: NextApiResponse<SignOutMutation | { errors: readonly any[] }>
) => {
  if (req.method !== 'POST') {
    return res
      .setHeader('Allow', ['POST'])
      .status(405)
      .end('Method Not Allowed')
  }

  const token  = req.cookies['Starlight-Session-Token']
  const client = createServerSideClient(token)

  const { data, errors } = await client.mutate<SignOutMutation>({
    mutation: SIGN_OUT_MUTATION,
    variables: { input: req.body },
    fetchPolicy: 'no-cache'
  })

  if (errors) { // Forward request level errors
    return res
      .status(400)
      .json({ errors })
  }

  if (!data) { // Somehow got no error and no data
    return res
      .status(500)
      .end('Internal Server Error')
  }

  return res
    .setHeader(
      'Set-Cookie',
      'Starlight-Session-Token=; Secure; Path=/; Max-Age=0'
    )
    .status(200)
    .json({ signOut: { success: true } })
}

export default handler
