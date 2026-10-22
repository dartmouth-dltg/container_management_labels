# Adds an indicator search (space separated list or numeric range like
# "[1 TO 10]") to the top container bulk operations search.
# Indicators are strings, so ranges are expanded to an exact-match OR list.
module TopContainersIndicatorSearch

  # stay under solr's default maxBooleanClauses (1024)
  MAX_INDICATORS = 1000
  RANGE = /\A\s*\[?\s*(\d+)\s+TO\s+(\d+)\s*\]?\s*\z/i

  private

  def perform_search
    unless params[:indicator].blank?
      clause = indicator_clause(params[:indicator])
      params[:q] = params[:q].blank? ? clause : "(#{params[:q]}) AND #{clause}"
    end

    super
  end

  def indicator_clause(input)
    indicators = if (m = RANGE.match(input))
                   (m[1].to_i..m[2].to_i).first(MAX_INDICATORS).map(&:to_s)
                 else
                   input.split.first(MAX_INDICATORS)
                 end

    "(" + indicators.map {|i| "indicator_u_stext:#{escape_solr(i)}"}.join(" OR ") + ")"
  end

  def escape_solr(term)
    term.gsub(/([+\-&|!(){}\[\]^"~*?:\\\/])/) { "\\#{$1}" }
  end
end
