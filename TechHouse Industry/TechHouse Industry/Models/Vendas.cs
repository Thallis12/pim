using TechBuildAPI.Models;

public class Vendas
{
    public int Id { get; set; }

    public int UsuarioId { get; set; }

    public Usuario Usuario { get; set; }

    public string ProdutoNome { get; set; } = "";
    public string ProdutoTipo { get; set; } = "";

    public decimal Preco { get; set; }
    public int Quantidade { get; set; }

    public int CompraId { get; set; }

    // Status possíveis:
    // "Em Preparo"   → admin acabou de receber, cliente pode cancelar
    // "Em Transporte" → admin enviou, cliente NÃO pode mais cancelar
    // "Entregue"     → admin marcou como entregue, cliente pode devolver
    // "Cancelada"    → cancelada pelo cliente (só até Em Preparo) ou pelo admin
    // "Devolvida"    → cliente devolveu (motivo: Desistência / Outro)
    // "Perda"        → cliente devolveu por Defeito (conta como perda no gráfico)
    public string Status { get; set; } = "Em Preparo";

    public DateTime Data { get; set; } = DateTime.Now;

    public Compra Compra { get; set; }

    public string Origem { get; set; } = "";

    // Motivo da devolução: "Defeito" | "Desistencia" | "Outro: <texto livre>"
    public string? MotivoDevolicao { get; set; }
}