import httpProxy from 'http-proxy'
import { NextApiRequest, NextApiResponse } from 'next'

export const config = {
  api: {
    externalResolver: true,
    bodyParser: false
  }
}

const handler = async (
  req: NextApiRequest,
  res: NextApiResponse
) => {
  if (req.method !== 'POST') {
    return res
      .setHeader('Allow', ['POST'])
      .status(405)
      .end('Method Not Allowed')
  }

  return new Promise((resolve, reject) => {
    const proxy: httpProxy = httpProxy.createProxy()
    const token = req.cookies['Starlight-Session-Token']

    proxy
      .once('proxyReq', (proxyReq) => {
        proxyReq.removeHeader('Cookie')
        token && proxyReq.setHeader('Authorization', `Starlight ${token}`)
      })
      .once('proxyRes', resolve)
      .once('error', reject)
      .web(req, res, {
        ignorePath: true,
        target: process.env.GRAPHQL_API_URL
      })
  })
}

export default handler
