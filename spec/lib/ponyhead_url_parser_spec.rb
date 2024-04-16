# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PonyheadURLParser do
  subject(:parser) { described_class.new(url) }

  describe '#parse' do
    subject(:parse) { parser.parse }

    let(:url) { 'https://ponyhead.com/deckbuilder?v1code=sb2x1-de12x1-de11x1-fm137x2' }

    it 'returns the cards from the URL' do
      expect(parse).to eq(
        'sb2'   => 1,
        'de11'  => 1,
        'de12'  => 1,
        'fm137' => 2
      )
    end

    context 'when the URL is invalid' do
      let(:url) { 'not a URL' }

      it 'raises an error' do
        expect { parse }.to raise_error(PonyheadURLParser::ParseError, 'is not a valid URL')
      end
    end

    context 'when the URL has an invalid scheme' do
      let(:url) { 'ftp://ponyhead.com/deckbuilder?v1code=sb2x1-de12x1-de11x1-fm137x2' }

      it 'raises an error' do
        expect { parse }.to raise_error(PonyheadURLParser::ParseError, 'must an http:// or https:// URL')
      end
    end

    context 'when the URL has an invalid host' do
      let(:url) { 'https://example.com/deckbuilder?v1code=sb2x1-de12x1-de11x1-fm137x2' }

      it 'raises an error' do
        expect { parse }.to raise_error(PonyheadURLParser::ParseError, 'must be hosted on ponyhead.com')
      end
    end

    context 'when the URL has an invalid path' do
      let(:url) { 'https://ponyhead.com/not-a-deckbuilder?v1code=sb2x1-de12x1-de11x1-fm137x2' }

      it 'raises an error' do
        expect { parse }.to raise_error(PonyheadURLParser::ParseError, 'must be a deckbuilder or short URL')
      end
    end

    context 'when the URL has an invalid query' do
      let(:url) { 'https://ponyhead.com/deckbuilder?notv1code=sb2x1-de12x1-de11x1-fm137x2' }

      it 'raises an error' do
        expect { parse }.to raise_error(PonyheadURLParser::ParseError, 'does not contain a decklist')
      end
    end

    context 'with a large decklist' do
      let(:url) { <<-TEXT.squish }
        https://ponyhead.com/deckbuilder?v1code=fm159x3-nd156x3-ll146x3-sb142x2-ll126x2-sb116x3-sb141x3-sb110x3-nd154x3-ff94x3-de135x3-ll16x2-nd141x1-fm89x3-fm15x3-fm86x2-fm93x3-ll132x1-fm141x2-fm138x2-nd137x2-ll128x1-pw13x3-nd159x2-ff141x3
      TEXT

      it 'returns the cards from the URL' do
        expect(parse).to eq(
          'fm159' => 3, 'nd156' => 3, 'll146' => 3, 'sb142' => 2, 'll126' => 2,
          'sb116' => 3, 'sb141' => 3, 'sb110' => 3, 'nd154' => 3, 'ff94'  => 3,
          'de135' => 3, 'll16'  => 2, 'nd141' => 1, 'fm89'  => 3, 'fm15'  => 3,
          'fm86'  => 2, 'fm93'  => 3, 'll132' => 1, 'fm141' => 2, 'fm138' => 2,
          'nd137' => 2, 'll128' => 1, 'pw13'  => 3, 'nd159' => 2, 'ff141' => 3
        )
      end
    end

    context 'with a short URL' do
      let(:url) { 'http://ponyhead.com/d/5k9wgUjHnL' }

      it 'returns the cards from the URL' do
        expect(parse).to eq(
          'sb2'   => 1,
          'de11'  => 1,
          'de12'  => 1,
          'fm137' => 2
        )
      end

      context 'with a malformed short URL' do
        let(:url) { 'http://ponyhead.com/d/invalid' }

        it 'raises an error' do
          expect { parse }.to raise_error(PonyheadURLParser::ParseError, 'is not a valid short URL')
        end
      end

      context 'with a large decklist' do
        let(:url) { 'https://ponyhead.com/d/plF_KKlZ0qhMjjxiNGH6YSpYcuJZWeCxX-M6iVeUVqppw' }

        it 'returns the cards from the URL' do
          expect(parse).to eq(
            'fm159' => 3, 'nd156' => 3, 'll146' => 3, 'sb142' => 2, 'll126' => 2,
            'sb116' => 3, 'sb141' => 3, 'sb110' => 3, 'nd154' => 3, 'ff94'  => 3,
            'de135' => 3, 'll16'  => 2, 'nd141' => 1, 'fm89'  => 3, 'fm15'  => 3,
            'fm86'  => 2, 'fm93'  => 3, 'll132' => 1, 'fm141' => 2, 'fm138' => 2,
            'nd137' => 2, 'll128' => 1, 'pw13'  => 3, 'nd159' => 2, 'ff141' => 3
          )
        end
      end
    end
  end
end
