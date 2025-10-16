# Conversion Graph - for direct unit-to-unit conversions
# Uses graph structure for finding conversion paths between related units
# All data structures are const (no __init__ needed)

# Struct to represent a conversion edge
struct ConversionEdge
    from_unit::String
    to_unit::String
    factor::Float64  # multiply by this factor to convert from -> to
end

# All direct conversion relationships
# Each entry defines a bidirectional conversion
const CONVERSION_EDGES = [
    # Time conversions
    ConversionEdge("s", "minute", 1/60.0),
    ConversionEdge("minute", "hour", 1/60.0),
    ConversionEdge("hour", "day", 1/24.0),
    ConversionEdge("day", "week", 1/7.0),

    # Length conversions
    ConversionEdge("m", "km", 0.001),
    ConversionEdge("m", "cm", 100.0),
    ConversionEdge("m", "mm", 1000.0),
    ConversionEdge("m", "ft", 3.28084),
    ConversionEdge("ft", "in", 12.0),

    # Mass conversions
    ConversionEdge("kg", "g", 1000.0),
    ConversionEdge("kg", "lb", 2.20462),
]

# Build adjacency list representation for graph traversal
const CONVERSION_GRAPH = let
    graph = Dict{String, Vector{Tuple{String, Float64}}}()

    # Add all edges (bidirectional)
    for edge in CONVERSION_EDGES
        # Forward direction
        if !haskey(graph, edge.from_unit)
            graph[edge.from_unit] = Vector{Tuple{String, Float64}}()
        end
        push!(graph[edge.from_unit], (edge.to_unit, edge.factor))

        # Reverse direction (inverse factor)
        if !haskey(graph, edge.to_unit)
            graph[edge.to_unit] = Vector{Tuple{String, Float64}}()
        end
        push!(graph[edge.to_unit], (edge.from_unit, 1.0 / edge.factor))
    end

    graph
end

# Find conversion factor between two units using graph traversal (BFS)
function find_conversion_path(from_unit::String, to_unit::String)::Union{Float64, Nothing}
    if from_unit == to_unit
        return 1.0
    end

    if !haskey(CONVERSION_GRAPH, from_unit)
        return nothing
    end

    # BFS to find path
    visited = Set{String}()
    queue = [(from_unit, 1.0)]  # (current_unit, accumulated_factor)

    while !isempty(queue)
        current, factor = popfirst!(queue)

        if current == to_unit
            return factor
        end

        if current in visited
            continue
        end
        push!(visited, current)

        if haskey(CONVERSION_GRAPH, current)
            for (neighbor, edge_factor) in CONVERSION_GRAPH[current]
                if !(neighbor in visited)
                    push!(queue, (neighbor, factor * edge_factor))
                end
            end
        end
    end

    return nothing
end
