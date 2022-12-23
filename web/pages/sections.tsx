import { gql } from '@apollo/client'
import type { NextPage } from 'next'
import { useSectionsQuery } from '../lib/generated/graphql'

gql`
  query Sections {
    sections {
      nodes {
        id
        title
        slug
        description
      }
    }
  }
`

const SectionsPage: NextPage = () => {
  const { data, loading } = useSectionsQuery()

  if (loading) {
    return (
      <div>Loading...</div>
    )
  }

  if (!data?.sections?.nodes) {
    return null // TODO: Handle error
  }

  return (
    <>
      {data.sections.nodes.map((section) => (
        section && (
          <div key={section.id}>
            <h2>{section.title}</h2>
            <p>{section.description}</p>
          </div>
        )
      ))}
    </>
  )
}

export default SectionsPage
