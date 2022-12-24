import { randomUUID } from 'crypto'
import type { GetServerSideProps, NextApiHandler, NextPage } from 'next'

export type CSRFTokenProp = { 'Starlight-CSRF-Token': string }

export const injectCSRFToken = (handler: GetServerSideProps = async (_) => ({ props: {} })): GetServerSideProps => (
  async (context) => {
    const result = await handler(context)

    if ('props' in result) {
      let csrfToken = context.req.cookies['Starlight-CSRF-Token']

      if (!csrfToken) {
        csrfToken = randomUUID()

        context.res.setHeader(
          'Set-Cookie',
          `Starlight-CSRF-Token=${csrfToken}; Secure; Path=/; HttpOnly; SameSite=Lax`
        )
      }

      result.props = {
        ...result.props,
        'Starlight-CSRF-Token': csrfToken
      }
    }

    return result
  }
)

export const validateCSRFToken = <T>(handler: NextApiHandler<T>): NextApiHandler<T> => (
  async (req, res) => {
    const cookieToken = req.cookies['Starlight-CSRF-Token']
    const headerToken = req.headers['starlight-csrf-token']

    if (!cookieToken || !headerToken || cookieToken !== headerToken) {
      return res
        .status(400)
        .end('Missing or invalid CSRF token')
    }

    return handler(req, res)
  }
)
