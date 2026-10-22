# Adds an indicator search (space separated list or numeric range like
# "[1 TO 10]") to the top container bulk operations search.
# Indicators are strings, so ranges are expanded to an exact-match OR list.
module TopContainersIndicatorSearch

  # stay under solr's default maxBooleanClauses (1024)
  MAX_INDICATORS = 1000
  RANGE = /\A\s*\[?\s*(\d+)\s+TO\s+(\d+)\s*\]?\s*\z/i

  # core's csv export builds its query from the request params without going
  # through perform_search, so add the indicator filter here too
  def index
    add_indicator_query if request.format.csv?
    super
  end

  private

  def perform_search
    add_indicator_query
    super
  end

  def add_indicator_query
    return if params[:indicator].blank?

    clause = indicator_clause(params[:indicator])
    params[:q] = params[:q].blank? ? clause : "(#{params[:q]}) AND #{clause}"
  end

  def indicator_clause(input)
    indicators = if (m = RANGE.match(input))
                   from, to = [m[1].to_i, m[2].to_i].minmax
                   (from..to).first(MAX_INDICATORS).map(&:to_s)
                 else
                   input.split.first(MAX_INDICATORS)
                 end

    "(" + indicators.map {|i| "indicator_u_stext:#{escape_solr(i)}"}.join(" OR ") + ")"
  end

  def escape_solr(term)
    term.gsub(/([+\-&|!(){}\[\]^"~*?:\\\/])/) { "\\#{$1}" }
  end
end
