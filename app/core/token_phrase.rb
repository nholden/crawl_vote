class TokenPhrase

  ADJECTIVES = %w(
    malty
    grainy
    rich
    deep
    roasty
    smoky
    sweet
    autumnal
    rustic
    layered
    piney
    citrusy
    grapefruity
    earthy
    musty
    spicy
    sharp
    bright
    fresh
    herbal
    zippy
    lemony
    aromatic
    floral
    brilliant
    minty
    pungent
    elegant
    grassy
    tropical
    subtle
    fruity
    clean
    dank
  )

  NOUNS = %w(
    ale
    lager
    stout
    porter
    amber
    blonde
    brown
    cream
    pilsner
    red
    wheat
    riesling
    chardonnay
    merlot
    pinot
    martini
    margarita
    mojito
    manhattan
    mule
    cosmo
    sour
    mimosa
    julep
    gimlet
  )

  NUMBERS = (10..99).to_a

  def self.generate
    [ADJECTIVES, NOUNS, NUMBERS].map(&:sample).join
  end

end
