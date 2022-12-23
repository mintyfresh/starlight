import type { NextPage } from 'next'
import { useState } from 'react'
import { Button, ButtonToolbar, Form } from 'react-bootstrap'
import type { SignInMutation } from '../lib/generated/graphql'

const SignIn: NextPage = () => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')

  return (
    <Form onSubmit={async (event) => {
      event.preventDefault()

      const response = await fetch('/api/auth/sign-in', {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ email, password })
      })

      const data = await response.json() as SignInMutation | { errors: any[] }
      console.log(data)
    }}>
      <Form.Group className="mb-3">
        <Form.Label htmlFor="signInEmail">Email</Form.Label>
        <Form.Control
          id="signInEmail"
          type="email"
          value={email}
          onChange={(event) => setEmail(event.target.value)}
          autoComplete="email"
        />
      </Form.Group>
      <Form.Group className="mb-3">
        <Form.Label htmlFor="signInPassword">Password</Form.Label>
        <Form.Control
          id="signInPassword"
          type="password"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          autoComplete="current-password"
        />
      </Form.Group>
      <ButtonToolbar>
        <Button variant="primary" type="submit">
          Sign In
        </Button>
      </ButtonToolbar>
    </Form>
  )
}

export default SignIn
