import type { CodegenConfig } from '@graphql-codegen/cli'

const config: CodegenConfig = {
  overwrite: true,
  schema: 'http://localhost:3000/graphql',
  documents: '{components,lib,pages}/**/*.{ts,tsx}',
  generates: {
    'lib/generated/graphql.ts': {
      plugins: [
        'typescript',
        'typescript-operations',
        'typescript-react-apollo',
        'fragment-matcher'
      ]
    },
    './graphql.schema.json': {
      plugins: ['introspection']
    }
  },
  config: {
    scalars: {
      ISO8601Date: 'string',
      ISO8601DateTime: 'string'
    }
  }
}

export default config
