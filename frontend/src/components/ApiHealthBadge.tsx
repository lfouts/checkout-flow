import { useQuery } from "@tanstack/react-query";
import { api } from "../api/client";

// Small connectivity indicator — proves the frontend can reach the backend
// (and that CORS is configured). Handy while building out the API.
export function ApiHealthBadge() {
  const { data, isLoading, isError } = useQuery({
    queryKey: ["health"],
    queryFn: api.health,
    retry: false,
  });

  const { label, color } = isLoading
    ? { label: "checking API…", color: "bg-gray-400" }
    : isError
      ? { label: "API unreachable", color: "bg-red-500" }
      : { label: `API ${data?.status}`, color: "bg-green-500" };

  return (
    <span className="inline-flex items-center gap-2 text-xs text-gray-500">
      <span className={`h-2 w-2 rounded-full ${color}`} />
      {label}
    </span>
  );
}
