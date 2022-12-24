import { randomUUID } from 'crypto'
import type { GetServerSideProps, NextApiHandler } from 'next'

export const CSRF_TOKEN_COOKIE = 'Starlight-CSRF-Token'
export const CSRF_TOKEN_HEADER = 'starlight-csrf-token'
export const CSRF_TOKEN_PROP   = 'Starlight-CSRF-Token'

export type CSRFProp = { [CSRF_TOKEN_PROP]: string }

export const injectCSRFToken = (handler: GetServerSideProps = async (_) => ({ props: {} })): GetServerSideProps => (
  async (context) => {
    const result = await handler(context)

    if ('props' in result) {
      let csrfToken = context.req.cookies[CSRF_TOKEN_COOKIE]

      if (!csrfToken) {
        csrfToken = randomUUID()

        context.res.setHeader(
          'Set-Cookie',
          `${CSRF_TOKEN_COOKIE}=${csrfToken}; Secure; Path=/; HttpOnly; SameSite=Lax`
        )
      }

      result.props = {
        ...result.props,
        [CSRF_TOKEN_PROP]: csrfToken
      }
    }

    return result
  }
)

export const validateCSRFToken = <T>(handler: NextApiHandler<T>): NextApiHandler<T> => (
  async (req, res) => {
    const cookieToken = req.cookies[CSRF_TOKEN_COOKIE]
    const headerToken = req.headers[CSRF_TOKEN_HEADER]

    if (!cookieToken || !headerToken || cookieToken !== headerToken) {
      return res
        .status(400)
        .end('Missing or invalid CSRF token')
    }

    return handler(req, res)
  }
)
